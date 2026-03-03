import { prisma } from '@/lib/prisma'
import { UserRole } from '@prisma/client'

export async function createUserProfile(
    userId: string,
    email: string,
    fullName: string
) {
    return prisma.user.create({
        data: {
        id: userId,
        email,
        fullName,
        role: UserRole.USER,
        },
    })
}