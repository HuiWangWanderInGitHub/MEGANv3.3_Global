# Global Version Model of Emissions of Gases and Aerosols from Nature (Global-MEGAN)

> `megan` is a model used to estimate biogenic VOCs emissions, it has been developing by Alex Guenther and his group. This is a new version of MEGAN developed by Dr. Hui Wang for global biogenic reactive gases simulations based on Ram's code.

## Dependencies:

+  Fortran compiler
+  NetCDF library
+  MPI library

> &#9888; At this moment it only works on UNIX/Linux O.S. 

## Get MEGAN input data:

In order to run megan you will need meteorological and land data. 

Data required:
+ ERA5 NetCDF file. <!-- with the following variables: 'XLAT', 'XLONG', 'Times', 'MAPFAC_M', 'ISLTYP', 'U10', 'V10', 'T2', 'SWDOWN', 'PSFC', 'Q2', 'RAINNC', 'LAI', 'SMOIS', 'TSLB'. -->
+ Land vegetation fields needed. This version is driven by the gridded emission factors based on the vegetation species and corresponding emission factors. 

## Build
Go to the `src` directory:

`> cd src/`

Edit the Makefile to set the compiler and path to NetCDF lib and include files.

`> make`

If the compilation is successful, the executable `meganv3.3.exe` should be created at the `./exe` directory.

> &#9888; Note that the variables must be adjusted to match the appropriate values for your system. Check your `nc-config --libdir` and `nc-config --includedir` to fill NetCDF flags on Makefile.

## Run

Edit the namelist `namelist_megan` that contains the following variables:

```fortran
&megan_nl
  start_date='__START__',   ! YYYY-MM-DD HH:MM:SS
  end_date  ='__END__',   ! YYYY-MM-DD HH:MM:SS

  met_file_path = '/glade/campaign/univ/ucir0060/ERA5_land/unzip_era5land_2000-2020'
  lai_file_path = '/glade/campaign/univ/ucir0060/LAI4g_Regridded_0.1deg'
  pft_file_path = '/glade/campaign/univ/ucir0060/regridded_GF' 
  ef_file_path = '/glade/campaign/univ/ucir0060/Regridded_0.1deg_EF' 
  output_path   = '/glade/campaign/univ/ucir0060/Global_megan_output_2020' 
  co2_file = "co2_mm_gl.csv"

  met_files ='era5land_0.1degree_<time>.nc',            ! Meteo file path
  pft_files ='ESACCI_GF_0.1_Degree_<time>.nc'           ! pft file path
  ef_file  ='Gridded_GR_EF.nc'                          ! gridded emission factor file
  lai_files ='LAI4g_v1.2_0.1_Degree_<time>.nc'          ! LAI file path

  nlai= '24',                                           ! LAI record number
  lai_scale_factor = 0.1,                               ! LAI file scale factor

  run_flower = .false.                                  ! run flower emission (5% of the leaf level)
  run_litter = .false.                                  ! run litter emission (5% of the leaf level)
  real_spinup_met = .true.                              ! spin up for the long-term meterology
  output_ef_file  = .false.                             ! write the gridded emission factor
  run_co2 = .true.                                      ! consider the CO2 change(need the CO2 input file)
  output_gamma = .true.                                 ! output gamma value (need gridded ef file) or real emission
  diagnose = .false.                                    ! diagnose the model of isoprene
/
```

> &#9888; Note that the variables must be adjusted to match the appropriate values for your run.

Then execute `megan_v3.3.exe`:

`> ./megan_v3.3.exe < namelist_megan` 

Please feel free to contact the developer if you have any issues or suggestions.


---

