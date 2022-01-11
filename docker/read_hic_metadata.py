import io
import struct
import requests


def __readcstr(f):
    """ Helper function for reading in C-style string from file
    """
    buf = b""
    while True:
        b = f.read(1)
        if b is None or b == b"\0":
            return buf.decode("utf-8")
        elif b == "":
            raise EOFError("Buffer unexpectedly empty while trying to read null-terminated string")
        else:
            buf += b



def read_metadata(infile,verbose=False):
    """
    Reads the metadata of HiC file from header.
    Args
    infile: str, path to the HiC file 
    verbose: bool
    
    Returns
    metadata: dict, containing the metadata. 
                Keys of the metadata: 
                HiC version, 
                Master index, 
                Genome ID (str), 
                Attribute dictionary (dict), 
                Chromosomes (dict), 
                Base pair-delimited resolutions (list), 
                Fragment-delimited resolutions (list). 
    """
    metadata={}
    if (infile.startswith("http")):
        # try URL first. 100K should be sufficient for header
        headers={'range' : 'bytes=0-100000', 'x-amz-meta-requester' : 'straw'}
        s = requests.Session()
        r=s.get(infile, headers=headers)
        if (r.status_code >=400):
            print("Error accessing " + infile) 
            print("HTTP status code " + str(r.status_code))
            sys.exit(1)
        req=io.BytesIO(r.content)        
        myrange=r.headers['content-range'].split('/')
        totalbytes=myrange[1]
    else:
        req=open(infile, 'rb')
    magic_string = struct.unpack('<3s', req.read(3))[0]
    req.read(1)
    if (magic_string != b"HIC"):
        sys.exit('This does not appear to be a HiC file magic string is incorrect')
    version = struct.unpack('<i',req.read(4))[0]
    metadata['HiC version']=version 
    masterindex = struct.unpack('<q',req.read(8))[0]
    metadata['Master index']=masterindex
    genome = ""
    c=req.read(1).decode("utf-8") 
    while (c != '\0'):
        genome += c
        c=req.read(1).decode("utf-8") 
    metadata['Genome ID']=genome        
    if (version > 8):
        nvi = struct.unpack('<q',req.read(8))[0]
        nvisize = struct.unpack('<q',req.read(8))[0]
        metadata['NVI'] = nvi
        metadata['NVI size'] = nvisize
    ## read and throw away attribute dictionary (stats+graphs)
    nattributes = struct.unpack('<i',req.read(4))[0]
    d={}
    for x in range(0, nattributes):
        key = __readcstr(req)
        value = __readcstr(req)
        d[key]=value
    metadata['Attribute dictionary']=d
    nChrs = struct.unpack('<i',req.read(4))[0]
    d={}
    for x in range(0, nChrs):
        key = __readcstr(req)
        if (version > 8):
            value = struct.unpack('q',req.read(8))[0]
        else:
            value = struct.unpack('<i',req.read(4))[0]
        d[key]=value
    metadata["Chromosomes"]=d
    nBpRes = struct.unpack('<i',req.read(4))[0]
    l=[]
    for x in range(0, nBpRes):
        res = struct.unpack('<i',req.read(4))[0]
        l.append(res)
    metadata["Base pair-delimited resolutions"]=l        
    nFrag = struct.unpack('<i',req.read(4))[0]
    l=[]
    for x in range(0, nFrag):
        res = struct.unpack('<i',req.read(4))[0]
        l.append(res)
    metadata["Fragment-delimited resolutions"]=l 
    for k in metadata:
        if k!='Attribute dictionary':
            print(k,':',metadata[k])
    if verbose:
        print('Attribute dictionary',':',metadata['Attribute dictionary'])        
    return metadata


