/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/**/*.{js,jsx,ts,tsx}",
    "./components/**/*.{js,jsx,ts,tsx}",
  ],
  presets: [require("nativewind/preset")],
  theme: {
    extend: {
      colors: {
        // My Sea Design System
        primary: {
          DEFAULT: '#E0F7FA',
          light: '#E0F7FA',
          dark: '#0288D1',
        },
        secondary: '#0288D1',
        surface: '#FFFFFF',
        accent: {
          DEFAULT: '#FFAB91',
          coral: '#FFAB91',
        },
        text: {
          main: '#263238',
          sub: '#78909C',
        },
        ocean: {
          shallow: '#E0F7FA',
          mid: '#4FC3F7',
          deep: '#0288D1',
          abyss: '#01579B',
        },
      },
      fontFamily: {
        sans: ['Pretendard', 'system-ui', 'sans-serif'],
        rounded: ['Nunito', 'sans-serif'],
      },
      borderRadius: {
        '4xl': '2rem',
      },
    },
  },
  plugins: [],
}
