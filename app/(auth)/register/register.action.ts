"use server"

import { registerSchema } from "@/schemas/auth.schema"
import { registerUser } from "@/services/auth.service"
import { RegisterState } from "@/types/formState"
import { redirect } from "next/navigation"

export async function registerAction(prevState: RegisterState, formData: FormData): Promise<RegisterState> {
    
    // Zod validation
    const rawData = {
        fullName: formData.get("fullName"),
        email: formData.get("email"),
        password: formData.get("password")
    }

    const parsed = registerSchema.safeParse(rawData)

    if (!parsed.success) {
        return { error: parsed.error.issues[0].message}
    }
    
    try {
        await registerUser(parsed.data.fullName, parsed.data.email, parsed.data.password)
    } catch (err: unknown) {
        const message = err instanceof Error ? err.message: "Something went wrong"
        return { error: message }
    }

    redirect("/dashboard")
}