import { prisma } from "@/lib/prisma"
import { cache } from "react"

export const getUserSubscriptionOrders = cache(async (userId: string) => {
    return prisma.subscriptionOrder.findMany({where: { userId }})
})