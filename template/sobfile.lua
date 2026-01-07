local conf = require('sob.conf')

conf.class_paths = { 'src' }
conf.main = 'Main'

conf.target = 'hl'
conf.output = 'out/main.hl'
conf:hxml('build')
