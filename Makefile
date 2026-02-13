.PHONY: install test lint run console clean

install:
	bundle install

test:
	bundle exec rspec

lint:
	bundle exec rubocop

lint-fix:
	bundle exec rubocop -A

run:
	bundle exec ruby bin/daniel70weeks

console:
	bundle exec irb -r ./settings.rb

clean:
	rm -rf .bundle vendor
