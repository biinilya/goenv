# goenv

Golang virtualenv wrapper. It is easy to use, just run the following inside your working directory

	goon
	
Yeah, thats it.

## Lazy installation (a.k.a oneliner)

Execute this command every time you need to use *goenv*

    GF=$(mktemp -t goenv); curl -s https://raw.githubusercontent.com/biinilya/goenv/master/activate.sh > $GF; source $GF

Downside of these method is that you always need an internet connection. But profit is that you are always up to date.

## Offline usage installation

Get the script

	curl https://raw.github.com/biinilya/goenv/master/activate.sh -o ~/.goenv_activate.sh
	
Source it to get *goenv* commands available

	echo 'source ~/.goenv_activate.sh' >> ~/.profile
	
## Contributor installation

Fork the repo and clone it

	git clone git@github.com:<username>/goenv.git ~/devel/goenv
	
Source as for previous case, but this time from your local copy

	echo 'source ~/devel/goenv/activate.sh' >> ~/.profile
	
If you want to modify it and contribute you should create a branch for you forked copy, commit changes to this branch and create a pull request.
