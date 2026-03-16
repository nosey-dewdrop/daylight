import { Stars } from '@/components/Stars'
import { ThemeToggle } from '@/components/ThemeToggle'

const STORIES: Record<string, { category: string; title: string; author: string; date: string; body: string }> = {
  'orpheus-eurydice': {
    category: 'mythology',
    title: 'Orpheus & Eurydice',
    author: 'damla',
    date: 'mar 1, 2026',
    body: `there is no older love letter than a song.

orpheus was the greatest musician who ever lived. when he played his lyre, rivers changed course. stones wept. wild animals lay still and listened.

and then he fell in love with eurydice.

their love was the kind that makes the gods nervous — too bright, too real, too human. so when eurydice stepped on a venomous snake and died on their wedding day, orpheus did what no mortal had ever done: he walked into the underworld to bring her back.

he played for hades and persephone. he played the sound of missing someone so much that your body forgets how to breathe. he played the silence of an empty bed. he played the way her name tasted in his mouth.

even the dead wept.

hades agreed: eurydice could follow orpheus back to the world of the living. but there was one condition — he could not look back. he had to trust that she was there, walking behind him, without seeing her face.

he almost made it.

at the very last moment, just before the light of the living world touched his skin, he turned. and she was there — reaching for him, eyes full of love and sorrow — and then she was gone. forever.

some people say orpheus failed because he was weak. but i think he turned because love makes you desperate for proof. you need to see the face of the person you love. you need to know they're real.

every letter we write is an act of faith — we send our words into the dark and trust that someone is there, walking behind us, reading in the light.

don't look back. trust the silence. the letter will arrive.`,
  },
  'kafka-milena': {
    category: 'literary love',
    title: "Kafka's Letters to Milena",
    author: 'damla',
    date: 'feb 20, 2026',
    body: `franz kafka and milena jesenská met twice in their lives. twice.

but between those meetings, kafka wrote hundreds of letters — letters so raw, so painfully honest, that reading them feels like eavesdropping on someone's soul.

"i am constantly trying to communicate something incommunicable, to explain something inexplicable, to tell about something i only feel in my bones."

kafka was terrified of intimacy. he broke off engagements. he lived alone. he burned most of his writing. but in his letters to milena, he was braver than he ever was in person.

he wrote about his fear of living. about the way anxiety sits in your chest like a stone. about how sometimes the only honest thing you can do is write a letter you're too afraid to say out loud.

milena was a journalist, a translator, a woman who refused to be small. she translated kafka's work into czech. she understood his silences better than anyone.

their letters are not a love story in the traditional sense. they never really "got together." kafka was too afraid, and milena was too alive, and the distance between prague and vienna was just far enough to make honesty possible.

but that's what makes their letters extraordinary — they prove that the truest version of yourself sometimes only exists in the space between sending and receiving.

every letter you write on forget-me-not carries a piece of kafka's courage. you're saying: i am afraid, but i will try to be honest with a stranger. and that is the bravest thing a person can do.`,
  },
  'heathcliff-catherine': {
    category: 'historical letters',
    title: 'Heathcliff & Catherine',
    author: 'damla',
    date: 'feb 14, 2026',
    body: `"whatever our souls are made of, his and mine are the same."

emily brontë wrote wuthering heights in 1847, in a parsonage on the yorkshire moors, and the world has never recovered.

catherine earnshaw and heathcliff are not a love story. they are a weather system. they are the kind of love that uproots trees and floods valleys and leaves everything changed.

catherine chooses respectability over heathcliff. she marries edgar linton. she gets the nice house, the nice husband, the nice life. and it destroys her. because you can't choose comfort over truth and expect your soul to survive.

heathcliff, abandoned, becomes cruel. he spends years accumulating power and wealth for the sole purpose of revenge. but revenge against what? against a world that told him his love wasn't enough. against a society that said a foundling couldn't love a gentleman's daughter.

brontë doesn't ask us to admire heathcliff and catherine. she asks us to recognize them. to see in their destructive, impossible, world-ending love something true about what it means to want someone so completely that their absence rewrites your entire existence.

"he's more myself than i am," catherine says. and that's the terrifying thing about real connection — it doesn't complete you. it reveals you. and sometimes what it reveals is unbearable.

the letters on forget-me-not won't destroy you. but the best ones might change you. and maybe that's enough.`,
  },
  'letter-of-the-week': {
    category: 'featured',
    title: 'Letter of the Week',
    author: 'sora',
    date: 'mar 10, 2026',
    body: `dear luna,

there's a japanese concept called "ma" — the space between. it's not emptiness. it's not silence. it's the pause between notes that makes music. the white space on a page that makes words breathe.

i've been thinking about ma a lot since we started writing.

in tokyo, everything moves fast. the trains, the people, the neon. but inside the trains, everyone is quiet. everyone is in their own ma — their own space between the noise.

i found your profile on forget-me-not three weeks ago. you said you collect stories and sunsets. i collect silences. i thought: here is someone who understands that the spaces between are where the real things live.

this letter took 85 hours to reach you. in that time, it crossed the sea of japan, the silk road, the bosphorus. it traveled the same route that spices and stories have traveled for thousands of years.

i like knowing that. i like knowing that my words are somewhere over the mountains right now, getting closer to you with every hour.

we live in a world that demands instant replies. read receipts. typing indicators. but you and i — we chose the slow way. we chose to trust the space between.

i don't know what you look like. i don't know the sound of your voice. but i know you read kafka and watch the stars and believe that slow things are the most beautiful things. and that is more than most people ever share.

write back when the words find you.

with patience,
sora`,
  },
}

export default async function BlogStoryPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params
  const story = STORIES[slug]

  if (!story) {
    return (
      <>
        <Stars />
        <div style={{ maxWidth: 640, margin: '0 auto', padding: '120px 24px', position: 'relative', zIndex: 1, textAlign: 'center' }}>
          <h2 style={{ fontSize: 22, color: 'var(--lilac)', marginBottom: 8 }}>story not found</h2>
          <a href="/blog" style={{ fontSize: 13 }}>&larr; back to blog</a>
        </div>
      </>
    )
  }

  return (
    <>
      <Stars />
      <nav className="topnav">
        <span className="nav-brand">forget-me-not<span>_ letters that last</span></span>
        <div className="nav-right">
          <a href="/blog" className="nav-link">blog</a>
          <ThemeToggle />
        </div>
      </nav>

      <div style={{ maxWidth: 640, margin: '0 auto', padding: '80px 24px 60px', position: 'relative', zIndex: 1 }}>
        <a href="/blog" style={{ fontSize: 12, color: 'var(--tx3)', marginBottom: 24, display: 'block' }}>&larr; back to blog</a>

        <div style={{ fontSize: 10, color: 'var(--gold)', textTransform: 'uppercase', letterSpacing: '0.1em', marginBottom: 8 }}>{story.category}</div>
        <h1 style={{ fontSize: 28, fontWeight: 700, color: 'var(--lilac)', marginBottom: 8 }}>{story.title}</h1>
        <div style={{ fontSize: 12, color: 'var(--tx4)', marginBottom: 32 }}>
          published by <span style={{ color: 'var(--lilac)' }}>@{story.author}</span> · {story.date}
        </div>

        <div style={{ fontSize: 14, color: 'var(--tx2)', lineHeight: 2, whiteSpace: 'pre-line' }}>
          {story.body}
        </div>

        <hr className="divider" style={{ marginTop: 40 }} />

        <div style={{ textAlign: 'center' }}>
          <p style={{ fontSize: 12, color: 'var(--tx4)', marginBottom: 16 }}>inspired? write a letter.</p>
          <a href="/compose" className="btn">compose a letter</a>
        </div>
      </div>
    </>
  )
}
