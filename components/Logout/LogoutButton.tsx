"use client"

import { logoutAction } from "./logout.action"

export function LogoutButton() {

    return (
        <form action={logoutAction}>
            <button
            type="submit"
            className="px-4 py-2 text-sm font-semibold text-gray-700 hover:text-gray-900 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
            >
                Logout
            </button>
        </form>
        
    )
}