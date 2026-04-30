/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        cyber: {
          primary: '#00FFFF',
          secondary: '#FF00FF',
          accent: '#00FF00',
          background: '#0A0A0F',
          surface: '#1A1A2E',
          medium: '#16213E',
          text: '#E0E0FF',
          textSecondary: '#8888AA',
          warning: '#FFAA00',
          error: '#FF3366',
        }
      },
      fontFamily: {
        mono: ['Courier New', 'monospace'],
      }
    },
  },
  plugins: [],
}