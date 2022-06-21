import type { HeadersFunction } from '@remix-run/node';
import { useLoaderData, useLocation, useMatches } from '@remix-run/react';
import { getColorScheme } from './cookie';
import lightTheme from './theme/lightTheme';
import darkTheme from './theme/darkTheme';
import type { LinksFunction, LoaderFunction, MetaFunction } from '@remix-run/node';
import { json } from '@remix-run/node';
import { Links, LiveReload, Meta, Outlet, Scripts, ScrollRestoration } from '@remix-run/react';
import { ChakraProvider } from '@chakra-ui/react';
import { withEmotionCache } from '@emotion/react';
import type { EmotionCache } from '@emotion/react';
import { useEmotionCache } from './hooks/useEmotionCache';
import DOMPurify from 'isomorphic-dompurify';
import tailwindStylesheetUrl from './styles/tailwind.css';
import { getUser } from './session.server';
import { useEffect } from 'react';
import { checkConnectivity } from '~/utils/client/pwa-utils.client';

export const links: LinksFunction = () => {
    return [{ rel: 'stylesheet', href: tailwindStylesheetUrl }];
};
export const meta: MetaFunction = () => ({
    charset: 'utf-8',
    title: 'Remix Notes',
    viewport: 'width=device-width,initial-scale=1'
});
type LoaderData = {
    user: Awaited<ReturnType<typeof getUser>>;
    colorScheme: string;
};
export const headers: HeadersFunction = () => ({
    'Accept-CH': 'Sec-CH-Prefers-Color-Scheme'
});
export const loader: LoaderFunction = async ({ request }) => {
    return json<LoaderData>({
        user: await getUser(request),
        colorScheme: await getColorScheme(request)
    });
};
interface DocumentProps {
    children: React.ReactNode;
}
const Document = withEmotionCache(({ children }: DocumentProps, emotionCache: EmotionCache) => {
    const serverStyleData = useEmotionCache(emotionCache);
    let location = useLocation();
    let matches = useMatches();

    useEffect(() => {
        let isMount = true;
        let mounted = isMount;
        isMount = false;
        if ('serviceWorker' in navigator) {
            if (navigator.serviceWorker.controller) {
                navigator.serviceWorker.controller?.postMessage({
                    type: 'REMIX_NAVIGATION',
                    isMount: mounted,
                    location,
                    matches,
                    manifest: window.__remixManifest
                });
            } else {
                let listener = async () => {
                    await navigator.serviceWorker.ready;
                    navigator.serviceWorker.controller?.postMessage({
                        type: 'REMIX_NAVIGATION',
                        isMount: mounted,
                        location,
                        matches,
                        manifest: window.__remixManifest
                    });
                };
                navigator.serviceWorker.addEventListener('controllerchange', listener);
                return () => {
                    navigator.serviceWorker.removeEventListener('controllerchange', listener);
                };
            }
        }
    }, [location, matches]);

    return (
        <html lang="en" className="h-full">
            <head>
                <link rel="manifest" href="/resources/manifest.json" />
                <Links /> <Meta />
                {serverStyleData.map(({ key, ids, css }) => (
                    <style
                        key={key}
                        data-emotion={`${key} ${ids.join(' ')}`}
                        dangerouslySetInnerHTML={{ __html: DOMPurify.sanitize(css) }}
                    />
                ))}
            </head>
            <body>
                {children} <ScrollRestoration /> <Scripts /> <LiveReload />
            </body>
        </html>
    );
});
export default function App() {
    const { colorScheme } = useLoaderData();

    const online = () => {
        //..Do something for online state
    };

    const offline = () => {
        //..Do something for offline state
    };

    useEffect(() => {
        // The `console.log` method returns an object with a status of "success" if online and a pass message or a status of "bad" and a fail message if offline
        checkConnectivity(online, offline).then((data) => console.log(data));
    }, []);
    return (
        <Document>
            <ChakraProvider theme={colorScheme === 'light' ? lightTheme : darkTheme}>
                <Outlet />
            </ChakraProvider>
        </Document>
    );
}
