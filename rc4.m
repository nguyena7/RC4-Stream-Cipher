clear all; close all; clc;
plaintext = input("Enter message to encrypt: ", 's');
iterations = input("Enter number of encryption iterations: ");
%plaintext = 'this homework';
disp("Original Plaintext: " + plaintext);

% Convert the plaintext to hex
M = dec2hex(plaintext);

% Initialize stream key
stream_key = ones(1, 256);
len = size(stream_key);
% Key scheduling
S = key_schedule(stream_key);

disp("Encrypting");
tic
for i = 1:iterations
    % Ciphertext, returned as hex
    ciphertext = stream_cipher(S, M); 
end
disp("Encryption: " + toc + " sec");
% Convert to ascii characters to display
ciphertextChars = char(hex2dec(ciphertext));
disp("Ciphertext: " + ciphertextChars.');

disp("Decrypting");
for i = 1:iterations
    % Decryption
    re_plaintext = stream_cipher(S, string(ciphertext).');
end
% Convert to ascii characters to display
re_plainttextChars = char(hex2dec(re_plaintext));
disp("Re-plaintext: " + re_plainttextChars.');

function S = key_schedule(K)
    keylen = 256;
    S = 1 : 1 : 256;
    T = reshape(zeros(1,256), 1, []);
    
    for i = 1:keylen-1
        T(i) = K(mod(i, keylen));
    end
    
    j = 1;
    for i = 1:keylen - 1
        j = mod((j + S(i) + T(i)), 256);
        S([i j]) = S([j i]);
    end
end

function ciphertext = stream_cipher(S, M)
    i = 1;
    j = 1;
    ciphertext = {};

    for idx = 1:size(M,1)
        i = mod((i + 1), 256);
        j = mod((j + S(i)), 256);
        S([i j]) = S([j i]);
        t = mod((S(i) + S(j)), 256);

        % Vector/type manipulation
        binBytes = hexToBinaryVector(M(idx,:), 8);
        byteCipher = bitxor(binBytes, de2bi(S(t), 8));
        ciphertext = [ciphertext, binaryVectorToHex(byteCipher)];
    end
end