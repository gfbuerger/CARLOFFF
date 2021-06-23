import sys
sys.path.append('/opt/src/caffe/python')
import numpy as np
import caffe

H = np.eye( 2, dtype = 'f4' ) 
H[1,0] = WGT
blob = caffe.io.array_to_blobproto( H.reshape( (1,1,2,2) ) )
with open( 'data/infogainH.binaryproto', 'wb' ) as f :
    f.write( blob.SerializeToString() )
