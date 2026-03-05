import { UserRole } from '@/generated/prisma/enums'
import { prisma } from '@/lib/prisma'

export async function createUserProfile(userId: string,email: string,fullName: string) {
    return prisma.user.create({
        data: {
        id: userId,
        email,
        fullName,
        role: UserRole.USER,
        },
    })
}