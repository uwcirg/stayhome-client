/* Matomo */
var _paq = window._paq || [];

(function() {
  
    /* prompt to add to homescreen */
    let deferredPrompt;
    const addBtn = document.querySelector('.add-button');
    if (addBtn) {
      addBtn.style.display = 'none';
      window.addEventListener('beforeinstallprompt', (e) => {
          // Prevent Chrome 67 and earlier from automatically showing the prompt
          e.preventDefault();
          // Stash the event so it can be triggered later.
          deferredPrompt = e;
          // Update UI to notify the user they can add to home screen
          addBtn.style.display = 'block';
        
          addBtn.addEventListener('click', (e) => {
            // hide our user interface that shows our A2HS button
            addBtn.style.display = 'none';
            // Show the prompt
            deferredPrompt.prompt();
            // Wait for the user to respond to the prompt
            deferredPrompt.userChoice.then((choiceResult) => {
                if (choiceResult.outcome === 'accepted') {
                  console.log('User accepted the A2HS prompt');
                } else {
                  console.log('User dismissed the A2HS prompt');
                }
                deferredPrompt = null;
              });
          });
        });
    }
    function requestPiwik() {
        var piwikID = 0;
        /*
         * retrieve app_settings.yaml
         */
        axios.get('../assets/assets/cfg/app_settings.yaml')
        .then(function (response) {
            // handle success
            if (!response || !response.data) {
                return;
            }
            var arrSettings = response.data.split("\n");
            if (!arrSettings.length) {
                return;
            }
            arrSettings.forEach(function(item) {
                if (piwikID) {
                    return true;
                }
                var arrItem = item.split(":");
                if (!arrItem.length) {
                    return true;
                }
                var key = arrItem[0];
                /*
                 *  note it will assume that the app_settings.yaml will contain piwikID config defined
                 *  e.g. piwikID = 15
                 */
                if (key == "piwikID") {
                    var val = arrItem[1] ? arrItem[1].replace(/\s/g, "") : "";
                    if (val) {
                        piwikID = val;
                    }
                }
            });
            setPiwikSite(piwikID);
        })
        .catch(function (error) {
            // handle error
            console.log(error);
        });
    }
    function setPiwikSite(siteID) {
        siteID = siteID || 15;

        /* tracker methods like "setCustomDimension" should be called before "trackPageView" */
        _paq.push(["setDocumentTitle", document.domain + "/" + document.title]);
        _paq.push(['trackPageView']);
    
        var u="https://piwik.cirg.washington.edu/";
        _paq.push(['setTrackerUrl', u+'matomo.php']);
        _paq.push(['setSiteId', siteID]);
        var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
        g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'matomo.js'; s.parentNode.insertBefore(g,s);
    }
    document.addEventListener("DOMContentLoaded", function() {
        try {
            requestPiwik();
        } catch(e) {
            console.log("error occurred handling piwik setup: " + e);
        }
    });
})();
