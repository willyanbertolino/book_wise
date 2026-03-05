import { prisma } from "@/lib/prisma"
import { createClient } from "@/lib/supabase/server"
import { cache } from "react"

export const getCurrentUser = cache(async () => {
    const supabase = await createClient()
    const {data: { user }} = await supabase.auth.getUser()

    if (!user) return null

    return prisma.user.findUnique({where: { id: user.id }})
})