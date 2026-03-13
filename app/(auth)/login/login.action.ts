"use server"

import { redirect } from "next/navigation"
import { loginUser } from "@/services/auth.service"
import { loginSchema } from "@/schemas/auth.schema"

export async function loginAction(prevState: any,formData: FormData) {
    const rawData = {
        email: formData.get("email"),
        password: formData.get("password")
    }

    const parsed = loginSchema.safeParse(rawData)

    if (!parsed.success) return {error: parsed.error.issues[0].message}

    try {
        await loginUser(parsed.data.email, parsed.data.password)
    } catch (err: unknown) {
        const message = err instanceof Error ? err.message: "Something went wrong"
        return { error: message }
    }

    redirect("/dashboard")
}