import sys
sys.path.append('/pf/b/b324017/local/caffe_BVLC/python')
import numpy as np
import caffe

H = np.eye( 2, dtype = 'f4' ) 
H[0,1] = 4.92
blob = caffe.io.array_to_blobproto( H.reshape( (1,1,2,2) ) )
with open( 'data/infogainH.binaryproto', 'wb' ) as f :
    f.write( blob.SerializeToString() )

