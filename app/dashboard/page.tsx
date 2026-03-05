import { LogoutButton } from "@/components/LogoutButton"
import { getCurrentUser } from "@/services/auth.service"

export default async function DashboardPage() {
    const user = await getCurrentUser()

    return (
        <div>
            <h1>Welcome {user?.fullName}</h1>
            <LogoutButton />
        </div>
    )
}