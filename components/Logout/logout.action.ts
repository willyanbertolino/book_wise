"use server"

import { redirect } from "next/navigation"
import { logoutUser } from "@/services/auth.service"

export async function logoutAction() {

    try {
        await logoutUser()
    } catch {
        // logout errors are ignored
    }

    redirect("/login")
}