document.addEventListener('DOMContentLoaded', function() {
    console.log('dom content loaded')

    const getPotentials = getMe => {
        const url = `http://localhost:3000/users/${getMe}`
        // const url = `https://mus-pairs-rails.herokuapp.com/users/${getMe}`
        const fetchSettings = {
            cache: 'default'
        }
        return fetch(url, fetchSettings)
            .then(res => {
                if (res.ok) {
                    return res.json()
                }
                throw new Error('Network response error')
            })
            .catch(err => {
                console.log('Error: ', err.message)
            })
    }

    console.log(getPotentials)
})
