import type { HeadersFunction } from "@remix-run/node";
import { useLoaderData } from "@remix-run/react";
import { getColorScheme } from "./cookie";
import lightTheme from "./theme/lightTheme";
import darkTheme from "./theme/darkTheme";
import type {
  LinksFunction,
  LoaderFunction,
  MetaFunction,
} from "@remix-run/node";
import { json } from "@remix-run/node";
import {
  Links,
  LiveReload,
  Meta,
  Outlet,
  Scripts,
  ScrollRestoration,
} from "@remix-run/react";

import tailwindStylesheetUrl from "./styles/tailwind.css";
import { getUser } from "./session.server";

export const links: LinksFunction = () => {
  return [{ rel: "stylesheet", href: tailwindStylesheetUrl }];
};

export const meta: MetaFunction = () => ({
  charset: "utf-8",
  title: "Remix Notes",
  viewport: "width=device-width,initial-scale=1",
});

type LoaderData = {
  user: Awaited<ReturnType<typeof getUser>>;
  colorScheme: string;
};

export const headers: HeadersFunction = () => ({
  "Accept-CH": "Sec-CH-Prefers-Color-Scheme",
});

export const loader: LoaderFunction = async ({ request }) => {
  return json<LoaderData>({
    user: await getUser(request),
    colorScheme: await getColorScheme(request),
  });
};

export default function App() {
  const { colorScheme } = useLoaderData();
  return (
    <Document>
      <ChakraProvider theme={colorScheme === "light" ? lightTheme : darkTheme}>
        <Outlet />
        <ScrollRestoration />
        <Scripts />
        <LiveReload />
      </body>
    </html>
  );
}
