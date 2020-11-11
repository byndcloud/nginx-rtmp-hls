const fs = require('fs')
const axios = require('axios').default

const baseUrl = `https://stream.minhasala.app/hls/`
const lives = ['CxYkSM29tXq7r3SO49q6',
  'MJvFoPIhUZ67KPfMQ8Co',
  'icrB7HXhCwcJ6GE9t9KW',
  'n0KP04GvSvvngBQ1sZ36',
  '4EoMtKEPURJJretPKvhv',
  'SMdCPgKJJTNDKXW2SxT1',
  '0EIh6p3LPGRo60svDtCV']


const downloadFile = (fileUrl, filePath) => {
  return new Promise((resolve, reject) => {
    axios
      .get(fileUrl, {
        responseType: 'stream'
      })
      .then(function (res) {
        if (res.data.pipe) {
          // console.log(`[${filePath}] response headers: `, { payload: res.headers })

          const stream = fs.createWriteStream(`downloads/${filePath}`, {
            resumable: false,
            public: true,
            metadata: {
              // Escavador don't return the corret content-type...
              // contentType: res.headers['content-type']
              // contentType: 'application/pdf; charset=UTF-8'
            }
          })
          res.data.pipe(stream)

          stream.on('finish', resolve)
          stream.on('close', resolve)
          stream.on('error', reject)
        } else {
          reject(`[${filePath}] Maybe res.data.pipe is undefined`)
        }
      })
  })
}

  ; (async () => {
    // Running for each a live a specific function-promise
    while (true) {

      lives.forEach(async live => {
        console.log('Gettings lives id', live)

        const { data } = await axios.get(`${baseUrl}${live}_720.m3u8`, {
          headers: {
            accept: "*/*",
            'accept-language': "en-US,en;q=0.9",
            'cache-control': "no-cache",
            pragma: "no-cache",
            'sec-fetch-dest': "empty",
            'sec-fetch-mode': "cors",
            'sec-fetch-site': "cross-site"
          }
        })


        const splitedLines = data.split('\n')

        // console.log('Download files')
        await Promise.all([
          downloadFile(baseUrl + splitedLines[5], splitedLines[5]),
          downloadFile(baseUrl + splitedLines[7], splitedLines[7]),
          downloadFile(baseUrl + splitedLines[9], splitedLines[9]),
          downloadFile(baseUrl + splitedLines[11], splitedLines[11]),
          downloadFile(baseUrl + splitedLines[13], splitedLines[13])
        ])

      })


      console.info('Waiting 2 seconds to download all again')
      await new Promise(resolve => setTimeout(resolve, 2000))
    }
  })()