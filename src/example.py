from progress.bar import Bar
import time

bar = Bar('Processing', max=20)
for i in range(20):
    # Do some work
    time.sleep(0.1)
    bar.next()
bar.finish()