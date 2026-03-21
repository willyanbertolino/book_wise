"use client"

import { User } from "@/generated/prisma/client"
import { createContext, useContext } from "react"

const UserContext = createContext<User | undefined>(undefined)

export function UserProvider({
    user,
    children,
}: {
    user: User
    children: React.ReactNode
}) {
    return (
        <UserContext.Provider value={user}>
            {children}
        </UserContext.Provider>
    )
}

export function useUser() {
    const context = useContext(UserContext)

    if (!context) {
        throw new Error("useUser must be used inside UserProvider")
    }

    return context
}