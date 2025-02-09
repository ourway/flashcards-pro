const CACHE_NAME = 'flashcards-app-cache-v1';
const urlsToCache = [
  '/',
  '/index.html',
  '/manifest.json',
  '/icon.png'
  // Add other assets (CSS, JS files, icons, etc.) as needed.
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(urlsToCache))
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => response || fetch(event.request))
  );
});

// Existing install/fetch code above...

// Listen for push events
self.addEventListener('push', event => {
  // Try to parse JSON from the push; fallback to text if not valid JSON
  let pushData;
  try {
    pushData = event.data.json();
  } catch (err) {
    pushData = { body: event.data.text() };
  }

  // Default icon or pass it in pushData
  const iconPath = '/icon.png';

  // Decide if it's a single card or multiple
  if (pushData.type === 'single' && pushData.question) {
    // One specific flashcard is due
    event.waitUntil(
      self.registration.showNotification('Flashcards Reminder', {
        body: `Time to review: ${pushData.question}`,
        icon: iconPath
      })
    );
  } else if (pushData.type === 'multiple' && pushData.count > 5) {
    // Large batch of flashcards
    event.waitUntil(
      self.registration.showNotification('Flashcards Reminder', {
        body: `Time to review ${pushData.count} questions now!`,
        icon: iconPath
      })
    );
  } else if (pushData.type === 'multiple') {
    // Fewer than or equal to 5, maybe list them or show a generic message
    event.waitUntil(
      self.registration.showNotification('Flashcards Reminder', {
        body: `It's time to review ${pushData.count} question(s).`,
        icon: iconPath
      })
    );
  } else {
    // Fallback if no recognized data
    event.waitUntil(
      self.registration.showNotification('Flashcards Reminder', {
        body: pushData.body || 'Time to review your flashcards!',
        icon: iconPath
      })
    );
  }
});

