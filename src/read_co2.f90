module co2_reader
  implicit none
contains

  subroutine read_co2_csv(filename, year, month, average, nrows)
    character(len=*),     intent(in) :: filename
    integer, allocatable, intent(out) :: year(:), month(:)
    real, allocatable,    intent(out) :: average(:)
    integer, intent(out) :: nrows

    integer :: i, ios, unit
    character(len=200) :: line
    character(len=20) :: year_s, month_s, avg_s

    ! Step 1: Count lines
    nrows = 0
    open(newunit=unit, file=filename, status='old', action='read', iostat=ios)
    if (ios /= 0) then
      print *, "Error opening file:", filename
      stop
    endif

    ! Skip header
    read(unit, '(A)')
    do
      read(unit, '(A)', iostat=ios) line
      if (ios /= 0) exit
      nrows = nrows + 1
    end do
    close(unit)

    ! Step 2: Allocate arrays
    allocate(year(nrows), month(nrows), average(nrows))

    ! Step 3: Read data
    open(newunit=unit, file=filename, status='old', action='read', iostat=ios)
    if (ios /= 0) then
      print *, "Error reopening file:", filename
      stop
    endif

    read(unit, '(A)')  ! Skip header
    do i = 1, nrows
      read(unit, *, iostat=ios) year_s, month_s, avg_s
      if (ios /= 0) then
        print *, "Error reading line", i
        stop
      endif
      read(year_s, *) year(i)
      read(month_s, *) month(i)
      read(avg_s, *) average(i)
    end do
    close(unit)
  end subroutine read_co2_csv

  function get_co2(years, months, co2_avg, target_year, target_month) result(avg)
    implicit none
    integer, intent(in) :: years(:), months(:), target_year, target_month
    real, intent(in)    :: co2_avg(:)
    real :: avg
    integer :: i
  
    avg = 420.  ! Default value (or use NaN if supported)
  
    do i = 1, size(years)
      if (years(i) == target_year .and. months(i) == target_month) then
        avg = co2_avg(i)
        return
      end if
    end do
  end function get_co2
end module co2_reader

