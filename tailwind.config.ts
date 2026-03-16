import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './app/**/*.{js,ts,jsx,tsx}',
    './components/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        bg:    '#0C0A10',
        bg1:   '#110F16',
        bg2:   '#17141E',
        bg3:   '#1E1A28',
        bg4:   '#252030',
        brd:   '#2A2538',
        brd2:  '#3A3450',
        lilac: {
          DEFAULT: '#B8A4D6',
          2: '#CDBDE8',
          3: '#9882BA',
          4: '#7B68A0',
        },
        pink: {
          DEFAULT: '#D4A0B9',
          2: '#E0B8CC',
        },
        plum:  '#6B4F7A',
        deep:  '#3D2A50',
        gold:  '#D4B896',
        txt:   '#EDE8F2',
        tx2:   '#B0A4BF',
        tx3:   '#7E7290',
        tx4:   '#514768',
      },
      fontFamily: {
        serif:  ['Cormorant Garamond', 'Georgia', 'serif'],
        sans:   ['Outfit', '-apple-system', 'sans-serif'],
        hand:   ['Caveat', 'cursive'],
      },
      borderRadius: {
        DEFAULT: '12px',
      },
    },
  },
  plugins: [],
}

export default config
