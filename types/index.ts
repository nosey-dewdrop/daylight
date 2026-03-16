export type Avatar = {
  id: number
  emoji: string
  name: string
  xp_required: number
}

export type User = {
  id: string
  display_name: string | null
  avatar_id: number | null
  age: number | null
  country: string | null
  city: string | null
  latitude: number | null
  longitude: number | null
  location_visible: boolean
  languages: string[]
  mbti: string | null
  zodiac: string | null
  bio: string | null
  current_book: string | null
  last_song: string | null
  life_motto: string | null
  soundtrack_url: string | null
  xp: number
  level: number
  is_premium: boolean
  onboarding_complete: boolean
  created_at: string
  last_active_at: string
}

export type Letter = {
  id: string
  sender_id: string | null
  recipient_id: string | null
  content: string
  stamp_id: number | null
  song_url: string | null
  status: 'DRAFT' | 'IN_TRANSIT' | 'DELIVERED' | 'READ' | 'EXPIRED' | 'MEMORY_BOX'
  is_bottle: boolean
  is_memory_box: boolean
  memory_box_recipient: string | null
  time_capsule_date: string | null
  distance_km: number | null
  delivery_hours: number | null
  sent_at: string | null
  delivers_at: string | null
  read_at: string | null
  created_at: string
}

export type Stamp = {
  id: number
  emoji: string
  name: string
  category: string
  xp_required: number
  is_premium: boolean
}

export type Interest = {
  id: number
  name: string
  category: string
}

export type BlogPost = {
  id: string
  author_id: string | null
  title: string
  slug: string
  excerpt: string | null
  content: string
  category: 'mythology' | 'historical_letters' | 'literary_love' | 'writing_prompts' | 'community'
  cover_image_url: string | null
  is_featured: boolean
  is_approved: boolean
  is_staff_pick: boolean
  published_at: string | null
  created_at: string
}

export type Notification = {
  id: string
  user_id: string
  type: string
  content: string | null
  read: boolean
  created_at: string
}
