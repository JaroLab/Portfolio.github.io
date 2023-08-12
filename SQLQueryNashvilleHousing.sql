
--Standarise date format

SELECT saleDate, CONVERT(date, saleDate)
FROM dbo.NashvilleHousing

UPDATE dbo.NashvilleHousing
SET SaleDate = CONVERT(date, SaleDate)


ALTER TABLE NashvilleHousing
ADD SaleDateConverted date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, Saledate)


SELECT saleDate, CONVERT(date, saleDate)
 SaleDateConverted, CONVERT(date, saleDate)


SELECT saleDate, CONVERT(date, saleDate)
 COUNT(*) FROM NashvilleHousing

SELECT saleDate, CONVERT(date, saleDate)
SELECT DISTINCT * FROM dbo.NashvilleHousing


--Populate property adress data

SELECT *
FROM dbo.NashvilleHousing
WHERE PropertyAddress IS NULL


SELECT a.ParcelID, a.PropertyAddress, b. ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress IS NULL


--Breaking out address

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255)
UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255)
UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255)
UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255)
UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255)
UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


--Change Y to Yes and N to No in 'sold as vacant'

SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END


--Remove duplicates

WITH RowNumCTE AS(
SELECT*,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				UniqueID
				) row_num
		

FROM PortfolioProject.dbo.NashvilleHousing
)
SELECT*
FROM RowNumCTE
WHERE row_num >1
ORDER BY PropertyAddress


--Delete unused columns

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress
