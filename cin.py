import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-single-levels',
    {
        'product_type': 'reanalysis',
        'variable': [
            'convective_inhibition',        ],
        'year': [
            '2018',
        ],
        'month': [
            '07',
        ],
        'day': [
            '12',
        ],
        'time': [
            '06:00',        ],
        'area': [
            55.25, 5.75, 47.25,
            15.25,
        ],
        'format': 'netcdf',
    },
    'download.nc')
