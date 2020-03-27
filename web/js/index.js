/* Matomo */
var _paq = window._paq || [];

(function() {
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
    try {
        requestPiwik();
    } catch(e) {
        console.log("error occurred handling piwik setup: " + e);
    }
})();
