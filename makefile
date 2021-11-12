deploy-client:
	npm install netlify-cli -g
	netlify deploy --dir=./export/HTML5 --prod
