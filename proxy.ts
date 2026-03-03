import { createServerClient } from '@supabase/ssr'
import type { NextRequest } from 'next/server'
import { NextResponse } from 'next/server'

export async function proxy(request: NextRequest) {
    const response = NextResponse.next()

    const supabase = createServerClient(
        process.env.NEXT_PUBLIC_SUPABASE_URL!,
        process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!,
        {
        cookies: {
            getAll() {
            return request.cookies.getAll()
            },
            setAll(cookiesToSet) {
            cookiesToSet.forEach(({ name, value, options }) =>
                response.cookies.set(name, value, options)
            )
            },
        },
        }
    )

    // Força validação e refresh automático
    const {
        data: { user },
    } = await supabase.auth.getUser()

    // 🔒 Proteção de rota
    if (!user && request.nextUrl.pathname.startsWith('/dashboard')) {
        return NextResponse.redirect(new URL('/login', request.url))
    }

    return response
    }

    export const config = {
    matcher: ['/dashboard/:path*'],
}