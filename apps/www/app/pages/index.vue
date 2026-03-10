<script setup lang="ts">
useHead({
  title: "Tourney - Tournament Management on Autopilot",
  meta: [
    {
      name: "description",
      content:
        "The platform that automatically manages brackets, crafts custom schedules, and runs events while your team does anything else.",
    },
  ],
})
</script>

<template>
  <div class="min-h-screen bg-white font-sans text-neutral-900 selection:bg-neutral-200">
    <!-- Header -->
    <header class="fixed top-0 left-0 right-0 z-50 bg-white/80 backdrop-blur-md border-b border-neutral-100">
      <div class="mx-auto max-w-7xl px-6 lg:px-8">
        <div class="flex h-16 items-center justify-between">
          <div class="flex items-center gap-8">
            <a href="/" class="flex items-center gap-2">
              <div class="h-6 w-6 bg-blue-600 rounded-[6px]"></div>
              <span class="text-xl font-bold tracking-tight">Tourney</span>
            </a>
            <nav class="hidden md:flex items-center gap-6">
              <a href="#" class="text-sm font-medium text-neutral-600 hover:text-neutral-900 transition-colors">Produkt</a>
              <a href="#" class="text-sm font-medium text-neutral-600 hover:text-neutral-900 transition-colors">Ressourcen</a>
            </nav>
          </div>
          <div class="flex items-center gap-4">
            <a href="http://localhost:3001" class="text-sm font-medium text-neutral-600 hover:text-neutral-900 transition-colors hidden sm:block">Zuschauer App</a>
            <a href="http://localhost:3000" class="rounded-full bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 transition-all active:scale-95">
              Admin Bereich
            </a>
          </div>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="relative pt-40 md:pt-48 pb-24 overflow-hidden">
      <!-- Glow Effect -->
      <div class="absolute inset-0 -z-10 bg-[radial-gradient(ellipse_80%_80%_at_50%_-20%,rgba(37,99,235,0.15),rgba(255,255,255,0))]"></div>
      
      <div class="mx-auto max-w-7xl px-6 lg:px-8">
        <!-- Hero Section -->
        <div class="max-w-3xl">
          <h1 class="text-5xl md:text-7xl font-semibold tracking-tighter text-neutral-900 leading-tight mb-6">
            Turniere veranstalten. <br />
            Ohne das Chaos.
          </h1>
          <p class="text-lg md:text-xl text-neutral-500 max-w-2xl leading-relaxed mb-10">
            Die Plattform, die automatisch optimale Setzlisten erstellt, komplexe Brackets verwaltet, maßgeschneiderte Spielpläne entwirft und die Organisation übernimmt, während sich dein Team auf alles andere konzentriert.
          </p>
          <div class="flex flex-col sm:flex-row items-start sm:items-center gap-4">
            <a href="http://localhost:3000" class="inline-flex items-center justify-center rounded-full bg-blue-600 px-6 py-3 text-base font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-600 focus:ring-offset-2 transition-all active:scale-95 shadow-sm">
              Admin Bereich
            </a>
            <a href="http://localhost:3001" class="inline-flex items-center justify-center rounded-full bg-white px-6 py-3 text-base font-medium text-neutral-700 hover:bg-neutral-50 border border-neutral-200 transition-all hover:border-neutral-300">
              Zuschauer App
            </a>
          </div>
        </div>

        <!-- Video / Dashboard Placeholder -->
        <div id="video-demo" class="mt-20 relative">
          <!-- Subtle blurred background for the video container -->
          <div class="absolute -inset-1 rounded-3xl bg-gradient-to-r from-blue-100 via-indigo-100 to-purple-100 opacity-70 blur-2xl"></div>
          
          <div class="relative w-full aspect-video rounded-3xl overflow-hidden bg-neutral-950 border border-neutral-800 shadow-2xl flex items-center justify-center group cursor-pointer">
            <!-- Simulated Video UI -->
            <div class="absolute inset-0 bg-gradient-to-tr from-neutral-900 to-neutral-800"></div>
            
            <!-- Play Button Overlay -->
            <div class="relative z-10 flex flex-col items-center gap-4 transition-transform duration-300 group-hover:scale-110">
              <div class="flex h-20 w-20 items-center justify-center rounded-full bg-white/10 backdrop-blur-sm border border-white/20 shadow-lg text-white">
                <svg class="h-8 w-8 ml-1" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M8 5v14l11-7z" />
                </svg>
              </div>
              <span class="text-white/60 font-medium tracking-wide uppercase text-sm">Product Demo</span>
            </div>
            
            <!-- Fake Browser/App Header -->
            <div class="absolute top-0 left-0 right-0 h-12 bg-neutral-950/50 backdrop-blur-md border-b border-white/10 flex items-center px-6 gap-2">
              <div class="flex gap-2">
                <div class="w-3 h-3 rounded-full bg-red-500/80"></div>
                <div class="w-3 h-3 rounded-full bg-yellow-500/80"></div>
                <div class="w-3 h-3 rounded-full bg-green-500/80"></div>
              </div>
            </div>
          </div>
        </div>

        <!-- Features Section -->
        <div class="mt-32 pt-16 border-t border-neutral-100">
          <div class="text-center mb-16">
            <h2 class="text-3xl md:text-5xl font-semibold tracking-tight text-neutral-900 mb-4">
              Alles, was du für makellose Turniere brauchst
            </h2>
            <p class="text-lg text-neutral-500 max-w-2xl mx-auto">
              Gebaut für Geschwindigkeit, Skalierbarkeit und Einfachheit. Wir übernehmen die harte Arbeit, damit du dich auf die Spieler und den Wettbewerb konzentrieren kannst.
            </p>
          </div>
          
          <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <!-- Feature 1 -->
            <div class="p-8 rounded-3xl bg-neutral-50/50 border border-neutral-100 hover:border-blue-100 hover:bg-blue-50/30 transition-colors group">
              <div class="w-12 h-12 rounded-xl bg-blue-100 text-blue-600 flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 002-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                </svg>
              </div>
              <h3 class="text-xl font-semibold text-neutral-900 mb-3">Automatisierte Spielpläne</h3>
              <p class="text-neutral-500 leading-relaxed">
                Generiere sofort optimierte Single- oder Double-Elimination-Brackets. Intelligente Setzlisten-Algorithmen stellen sicher, dass deine besten Spieler im Finale und nicht in der ersten Runde aufeinandertreffen.
              </p>
            </div>
            
            <!-- Feature 2 -->
            <div class="p-8 rounded-3xl bg-neutral-50/50 border border-neutral-100 hover:border-blue-100 hover:bg-blue-50/30 transition-colors group">
              <div class="w-12 h-12 rounded-xl bg-blue-100 text-blue-600 flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
              </div>
              <h3 class="text-xl font-semibold text-neutral-900 mb-3">Echtzeit-Tabellen</h3>
              <p class="text-neutral-500 leading-relaxed">
                Live-Ranglisten und Bracket-Ergebnisse werden direkt auf die Geräte der Spieler übertragen. Kein ständiges Neuladen von Seiten oder Gedränge um ausgedruckte Pläne mehr.
              </p>
            </div>
            
            <!-- Feature 3 -->
            <div class="p-8 rounded-3xl bg-neutral-50/50 border border-neutral-100 hover:border-blue-100 hover:bg-blue-50/30 transition-colors group">
              <div class="w-12 h-12 rounded-xl bg-blue-100 text-blue-600 flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                </svg>
              </div>
              <h3 class="text-xl font-semibold text-neutral-900 mb-3">Teilnehmerverwaltung</h3>
              <p class="text-neutral-500 leading-relaxed">
                Verwalte Anmeldungen, Check-ins, Wartelisten und Team-Roster mit einem einzigen Klick. Versende sofort Nachrichten an alle Teilnehmer.
              </p>
            </div>
          </div>
        </div>

        <!-- How it Works Section -->
        <div class="mt-32">
          <div class="flex flex-col md:flex-row gap-16 items-center">
            <div class="flex-1">
              <span class="text-blue-600 font-semibold tracking-wide uppercase text-sm mb-4 block">Wie es funktioniert</span>
              <h2 class="text-3xl md:text-5xl font-semibold tracking-tight text-neutral-900 mb-6">
                Vom Konzept zum Champion in drei Schritten
              </h2>
              
              <div class="space-y-8 mt-10">
                <div class="flex gap-4">
                  <div class="flex-shrink-0 w-8 h-8 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center font-bold text-sm">1</div>
                  <div>
                    <h4 class="text-lg font-semibold text-neutral-900">Regelwerk erstellen</h4>
                    <p class="text-neutral-500 mt-1">Definiere Spielformate, Punktesysteme und Phasensysteme. Mit unseren Vorlagen legst du in Sekunden los.</p>
                  </div>
                </div>
                <div class="flex gap-4">
                  <div class="flex-shrink-0 w-8 h-8 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center font-bold text-sm">2</div>
                  <div>
                    <h4 class="text-lg font-semibold text-neutral-900">Teilnehmer einladen</h4>
                    <p class="text-neutral-500 mt-1">Teile einen einzigen Link. Spieler registrieren sich, bilden Teams und verwalten ihre eigenen Check-ins in der Zuschauer App.</p>
                  </div>
                </div>
                <div class="flex gap-4">
                  <div class="flex-shrink-0 w-8 h-8 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center font-bold text-sm">3</div>
                  <div>
                    <h4 class="text-lg font-semibold text-neutral-900">Lass Tourney die Arbeit machen</h4>
                    <p class="text-neutral-500 mt-1">Sobald die Matches beginnen, zieht Tourney automatisch Sieger vor, benachrichtigt nächste Spieler und berechnet Tabellenstände.</p>
                  </div>
                </div>
              </div>
            </div>
            
            <div class="flex-1 w-full bg-neutral-100 rounded-3xl aspect-square md:aspect-[4/5] relative overflow-hidden border border-neutral-200">
              <!-- Decorative abstract representation of workflow -->
              <div class="absolute top-10 left-10 right-10 bottom-10 bg-white rounded-2xl shadow-sm border border-neutral-200 p-6 flex flex-col gap-4">
                <div class="w-1/3 h-4 bg-neutral-200 rounded-full"></div>
                <div class="w-full h-24 bg-neutral-50 rounded-xl border border-neutral-100 flex items-center px-4 gap-4">
                  <div class="w-10 h-10 rounded-full bg-blue-100"></div>
                  <div class="flex-1 space-y-2">
                    <div class="w-1/2 h-3 bg-neutral-200 rounded-full"></div>
                    <div class="w-1/4 h-2 bg-neutral-200 rounded-full"></div>
                  </div>
                  <div class="w-16 h-8 rounded-lg bg-neutral-900"></div>
                </div>
                <div class="w-full h-24 bg-neutral-50 rounded-xl border border-neutral-100 flex items-center px-4 gap-4">
                  <div class="w-10 h-10 rounded-full bg-blue-100"></div>
                  <div class="flex-1 space-y-2">
                    <div class="w-1/2 h-3 bg-neutral-200 rounded-full"></div>
                    <div class="w-1/4 h-2 bg-neutral-200 rounded-full"></div>
                  </div>
                  <div class="w-16 h-8 rounded-lg outline outline-1 outline-neutral-200 bg-white"></div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Testimonial Section -->
        <div class="mt-32 py-20 bg-neutral-50 rounded-[3rem] px-6 lg:px-20 text-center relative overflow-hidden">
          <!-- Quote Icon backbg -->
          <div class="absolute -top-10 -left-10 text-[15rem] leading-none text-neutral-200/50 font-serif select-none pointer-events-none">"</div>
          
          <div class="relative z-10 max-w-4xl mx-auto">
            <p class="text-2xl md:text-4xl leading-snug tracking-tight font-medium text-neutral-900 mb-10">
              "Früher haben wir um die 5 Stunden gebraucht, um Setzlisten manuell zu erstellen und Diskussionen aufzulösen. Mit Tourney veranstalten wir unsere wöchentlichen Events beinahe automatisch. Unser administrativer Aufwand ist quasi bei Null."
            </p>
            <div class="flex flex-col items-center justify-center gap-4">
              <div class="w-14 h-14 rounded-full bg-neutral-300 overflow-hidden shadow-sm">
                <!-- Fallback avatar -->
                <div class="w-full h-full bg-gradient-to-br from-blue-100 to-indigo-200 flex items-center justify-center text-blue-800 font-semibold text-xl">JD</div>
              </div>
              <div>
                <div class="font-semibold text-neutral-900">John Doe</div>
                <div class="text-neutral-500 text-sm">Hauptorganisator, Global Esports League</div>
              </div>
            </div>
          </div>
        </div>

        <!-- Final CTA Section -->
        <div class="my-32 bg-neutral-900 text-white rounded-[3rem] px-6 py-20 lg:py-24 text-center overflow-hidden relative">
          <div class="absolute inset-0 bg-[radial-gradient(ellipse_at_top,rgba(37,99,235,0.3),transparent_50%)]"></div>
          
          <div class="relative z-10 max-w-3xl mx-auto">
            <h2 class="text-4xl md:text-6xl font-semibold tracking-tighter mb-6">
              Bereit, deine Turniere auf das nächste Level zu bringen?
            </h2>
            <p class="text-lg text-neutral-400 mb-10 max-w-xl mx-auto">
              Schließe dich tausenden Organisatoren an, die entspanntere, schnellere und größere Turniere mit Tourney ausrichten.
            </p>
            <div class="flex flex-col sm:flex-row items-center justify-center gap-4">
              <a href="http://localhost:3000" class="inline-flex w-full sm:w-auto items-center justify-center rounded-full bg-blue-600 px-8 py-4 text-base font-medium text-white hover:bg-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 focus:ring-offset-neutral-900 transition-all active:scale-95 shadow-[0_0_20px_rgba(37,99,235,0.4)]">
                Kostenlos starten
              </a>
              <a href="http://localhost:3001" class="inline-flex w-full sm:w-auto items-center justify-center rounded-full bg-white/10 backdrop-blur-md px-8 py-4 text-base font-medium text-white hover:bg-white/20 border border-white/10 transition-all">
                Zuschauer App entdecken
              </a>
            </div>
            <p class="text-sm text-neutral-500 mt-6">Keine Kreditkarte nötig • Unlimitierte 16-Spieler-Brackets</p>
          </div>
        </div>
      </div>
    </main>

    <!-- Footer -->
    <footer class="border-t border-neutral-100 bg-neutral-50 py-12">
      <div class="mx-auto max-w-7xl px-6 lg:px-8 flex flex-col md:flex-row justify-between items-center gap-6 text-sm text-neutral-500">
        <div class="flex items-center gap-2">
          <div class="h-5 w-5 bg-blue-600 rounded-[4px]"></div>
          <span class="font-semibold text-neutral-900">Tourney</span>
        </div>
        <p>© 2026 Tourney Inc. Alle Rechte vorbehalten.</p>/p>
        <div class="flex gap-6">
          <a href="#" class="hover:text-neutral-900 transition-colors">Twitter</a>
          <a href="#" class="hover:text-neutral-900 transition-colors">GitHub</a>
          <a href="#" class="hover:text-neutral-900 transition-colors">Discord</a>
        </div>
      </div>
    </footer>
  </div>
</template>

<style>
/* You can add custom styles here if needed. But Tailwind handles most of it. */
</style>
