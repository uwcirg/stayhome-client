(cd $(dirname $0) && sed 's/": "/": "¬¬¬/g' intl_en.arb | sed 's/",/□",/g' | sed 's/"$/□"/g' > intl_mn.arb)
