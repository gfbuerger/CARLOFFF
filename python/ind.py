import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-single-levels',
    {
        'product_type': 'reanalysis',
        'variable': [
            'angle_of_sub_gridscale_orography', 'anisotropy_of_sub_gridscale_orography', 'convective_available_potential_energy',
            'convective_inhibition', 'k_index', 'orography',
            'slope_of_sub_gridscale_orography', 'standard_deviation_of_orography', 'total_totals_index',
        ],
        'year': [
            '2000', '2001', '2002',
            '2003', '2004', '2005',
            '2006', '2007', '2008',
            '2009', '2010', '2011',
            '2012', '2013', '2014',
            '2015', '2016', '2017',
            '2018', '2019', '2020',
        ],
        'month': [
            '05', '06', '07', '08',
        ],
        'day': [
            '01', '02', '03',
            '04', '05', '06',
            '07', '08', '09',
            '10', '11', '12',
            '13', '14', '15',
            '16', '17', '18',
            '19', '20', '21',
            '22', '23', '24',
            '25', '26', '27',
            '28', '29', '30',
            '31',
        ],
        'time': [
            '00:00', '06:00', '12:00',
            '18:00',
        ],
        'area': [
            55.25, 5.75, 47.25,
            15.25,
        ],
        'format': 'netcdf',
    },
    'data/ind.nc')
