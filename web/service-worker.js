// simple service worker per https://web.dev/codelab-make-installable/

self.addEventListener('install', (event) => {
  console.log('👷', 'install', event);
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  console.log('👷', 'activate', event);
  return self.clients.claim();
});

self.addEventListener('fetch', function(event) {
  //  console.log('👷', 'fetch', event);
  //  event.respondWith(fetch(event.request));
  event.respondWith(fetch(event.request).then(function(response) {
    if (!response.ok) {
      // An HTTP error response code (40x, 50x) won't cause the fetch() promise to reject.
      // We need to explicitly throw an exception to trigger the catch() clause.
      throw Error('response status ' + response.status);
    }

    // If we got back a non-error HTTP response, return it to the page.
    return response;
  }).catch(function(error) {
    console.warn('Constructing a fallback response, ' +
      'due to an error while fetching the real response:', error);

    // return error response as fallback.
    var fallbackResponse = {
      error: "fetching response failed"
    };

    // Construct the fallback response via an in-memory variable.
    return new Response(JSON.stringify(fallbackResponse), {
      headers: {'Content-Type': 'application/json'}
    });
  }));
});
