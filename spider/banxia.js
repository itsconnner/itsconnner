const axios = require('axios').default;

// axios({
//   method: 'get',
//   url: 'http://bit.ly/2mTM3nY',
// })

// The Promise object represents the eventual completion (or failure) of an asynchronous operation and its resulting value.
// get--异步
axios.get('https://www.banxia.cc/books/2687.html')
    .then(function (response)
    {
        console.log(response.data)
    })