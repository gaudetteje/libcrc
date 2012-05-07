function crc=crc16(data)
% CRC32  Generates the 16-bit CRC on a given data set
%
% C=CRC16(DATA)  calculates the 16-bit CRC from the input data using the
% polynomial 0x8005
%
% For validating and debugging:
%   WinHex (11.7 SR11) can calculate the CRC-16, which will correctly
%   replicate the CRC-16 calculated here
%
% See also crc32 calc_crc calc_crctable

% Author:   Jason Gaudette
% Company:  Naval Undersea Warfare Center (Newport, RI)
% Phone:    401.832.6601
% Email:    jason.e.gaudette@navy.mil
% Date:     20110125

% define 16-bit generator polynomial
crctable = calc_crctable('8005');   % CRC-16 polynomial code

% calculate the CRC32
crc = calc_crc(data,crctable);
