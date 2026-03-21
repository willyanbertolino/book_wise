import { prisma } from "@/lib/prisma"
import { createClient } from "@/lib/supabase/server"
import { createUserProfile } from "@/services/user.service"
import { redirect } from "next/navigation"
import { cache } from "react"

export async function registerUser(
    fullName: string,
    email: string,
    password: string
) {

    const supabase = await createClient()

    // Create user in Supabase Auth
    const { data, error } = await supabase.auth.signUp({
        email,
        password
    })

    if (error) {
        throw new Error(error.message)
    }

    const user = data.user

    if (!user) {
        throw new Error("User not created")
    }

    // Create profile in DB (Prisma)
    await createUserProfile(
        user.id,
        user.email!,
        fullName,
    )
}

export async function loginUser(email: string, password: string) {
    const supabase = await createClient()

    const { error } = await supabase.auth.signInWithPassword({
        email,
        password
    })

    if (error) {
        throw new Error(error.message)
    }
}

export async function logoutUser() {
    const supabase = await createClient()

    const { error } = await supabase.auth.signOut()

    if (error) {
        throw new Error(error.message)
    }
}

export const getCurrentUser = cache(async () => {
    const supabase = await createClient()
    const { data, error } = await supabase.auth.getUser()

    if (error || !data.user) return null

    const user = await prisma.user.findUnique({
        where: { id: data.user.id }
    })

    if (!user) return null

    return user
})

export async function getCurrentUserOrRedirect() {
    const user = await getCurrentUser()

    if (!user) redirect("/login")

    return user
}