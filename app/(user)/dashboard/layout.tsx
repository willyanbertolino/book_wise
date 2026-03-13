import { UserProvider } from "@/components/providers/UserProvider"
import { getCurrentUserOrRedirect } from "@/services/auth.service"

export default async function DashboardLayout({children}: {children: React.ReactNode}) {
  const user = await getCurrentUserOrRedirect()

  return (
    <UserProvider user={user}>
      {children}
    </UserProvider>
  )
}