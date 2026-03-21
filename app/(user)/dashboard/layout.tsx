import { getCurrentUserOrRedirect } from "@/services/auth.service"

export default async function DashboardLayout({children}: {children: React.ReactNode}) {
  await getCurrentUserOrRedirect()

  return (
    <>
      {children}
    </>
  )
}