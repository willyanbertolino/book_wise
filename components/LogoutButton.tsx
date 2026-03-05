"use client"

import { useRouter } from "next/navigation"
import { useState } from "react"

export function LogoutButton() {
    const router = useRouter()
    const [loading, setLoading] = useState(false)

    const handleLogout = async () => {
        setLoading(true)

        await fetch("/api/logout", {method: "POST"})

        router.replace("/login")
        router.refresh()
    }

    return (
        <button
            onClick={handleLogout}
            disabled={loading}
            className="px-4 py-2 bg-red-500 text-white rounded"
                >{loading ? "Logging out..." : "Logout"}
        </button>
    )
}