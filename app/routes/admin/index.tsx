import { Form } from '@remix-run/react';
import { json, redirect } from '@remix-run/node';
import type { LoaderFunction } from '@remix-run/node';
import { getUserId } from '~/session.server';

import { useOptionalUser } from '~/utils';

export const loader: LoaderFunction = async ({ request }) => {
    const userId = await getUserId(request);
    if (!userId) return redirect('/');
    return json({});
};

export default function Index() {
    const user = useOptionalUser();
    return (
        <div>
            <h1>This is the admin index page</h1>
            <p>Welcome {user?.email}</p>
            <Form action="/logout" method="post">
                <button type="submit">Logout</button>
            </Form>
        </div>
    );
}
