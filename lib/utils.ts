import { SubscriptionOrder } from "@prisma/client";

export function secondsToHoursMinutes(seconds: number) {
    const hours = Math.floor(seconds / 3600)
    const minutes = Math.floor((seconds % 3600) / 60)

    return `${hours}h ${minutes}m`
}

export function getTierColor (tier: string) {
    switch (tier) {
        case "LIFETIME":
            return "from-purple-600 to-pink-600"
        case "YEARLY":
            return "from-blue-600 to-indigo-600"
        case "MONTHLY":
            return "from-green-600 to-emerald-600"
        default:
            return "from-gray-600 to-gray-700"
    }
}

export function getTierBenefits(tier: string) {
    if(tier === "FREE") {
        return {
            title: "Free Tier",
            features: [
                "Browse all books catalog",
                "Read book descriptions",
                "View table of contents",
                "Listen to ONLY 10 seconds of audio",
                "All reviews and ratings"
            ],
            limitations: [
                "Cannot listen to full audio",
                "Cannot download PDF's",
                "No favorites feature"
            ]
        }
    } else {
        return {
            title: `${tier} Plan`,
            features: [
                "Full access to 10,000+ book sumaries",
                "Read complete summaries online",
                "Listen to full audio sumaries",
                "Download PDFs",
                "Add books to favorites",
                "Unlimited access"
            ],
            limitations: []
        }
    }
}

export function getOrderPending(orders: SubscriptionOrder[]){
    return orders.find(order => order.orderStatus === "PENDING")
}

export function formatCurrency(value: number | string, locale = "pt-BR", currency = "BRL") {
    return Number(value).toLocaleString(locale, {
        style: "currency",
        currency
    })
}