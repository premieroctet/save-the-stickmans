deploy-client:
	npm install netlify-cli -g
	cd client
	netlify deploy --dir=export --prod
