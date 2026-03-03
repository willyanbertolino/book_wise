import { NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { createUserProfile } from '@/services/user.service'
import { registerSchema } from '@/schemas/auth.schema'
import { getZodErrorMessage } from "@/lib/validation"

export async function POST(request: Request) {
    try {
        const body = await request.json()
        const parsed = registerSchema.safeParse(body)

        if (!parsed.success) {
            return NextResponse.json(
                { error: getZodErrorMessage(parsed.error) },
                { status: 400 }
            )
        }

        const {fullName, email, password} = parsed.data
        const supabase = await createClient()

        // Create user on Supabase Auth
        const { data, error } = await supabase.auth.signUp({email,password,})

        if (error) {
            return NextResponse.json(
                { error: error.message },
                { status: 400 }
            )
        }

        const user = data.user

        if (!user) {
        return NextResponse.json(
            { error: 'User not created' },
            { status: 500 }
        )
        }

        // Create user on db with prisma
        await createUserProfile(user.id, user.email!, fullName)

        return NextResponse.json({ success: true })

    } catch (err) {
        console.error('[REGISTER_ERROR]', err)

        return NextResponse.json(
            { error: 'Internal server error' },
            { status: 500 }
        )
    }
}