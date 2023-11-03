    close all;
    clear;
    clc;

    % Passo 1: Codifica��o de Huffman Aplicada � Imagem PNM com Armazenamento Bin�rio
    disp('Passo 1: Codifica��o de Huffman Aplicada � Imagem PNM com Armazenamento Bin�rio');

    % Carregar a imagem PNM
    imagem_pnm = imread('imagem.pnm');
    disp('Imagem carregada com sucesso.');

    % Transformar a imagem em uma matriz unidimensional
    vetor_imagem = imagem_pnm(:);

    % Calcular a frequ�ncia de ocorr�ncia de cada valor de pixel
    frequencia_imagem = hist(vetor_imagem, 0:255);
    disp('Frequ�ncia de ocorr�ncia calculada com sucesso.');

    % Calcular as probabilidades
    prob_imagem = frequencia_imagem / numel(vetor_imagem);

    % Criar uma tabela de Huffman
    tabela_huffman = huffmandict(0:255, prob_imagem);
    disp('Tabela de Huffman criada com sucesso.');

    % Gerar os c�digos Huffman
    sequencia_huffman = huffmanenco(vetor_imagem, tabela_huffman);
    disp('C�digos Huffman gerados com sucesso.');

    % Armazenar a sequ�ncia de bits comprimida em um arquivo bin�rio
    fid = fopen('imagemHuffman_codificada.bin', 'wb');
    fwrite(fid, sequencia_huffman);
    fclose(fid);
    disp('Sequ�ncia de bits comprimida armazenada em arquivo com sucesso.');

    disp("------------------------------------------------------------")

    % Passo 2: Decodifica��o de Huffman Aplicada � Imagem PNM com Armazenamento Bin�rio
    disp('Passo 2: Decodifica��o de Huffman Aplicada � Imagem PNM com Armazenamento Bin�rio');

    % Ler a sequ�ncia de bits comprimida a partir do arquivo bin�rio
    fid = fopen('imagemHuffman_codificada.bin', 'rb');
    sequencia_huffmanLida = fread(fid);
    fclose(fid);
    disp('Sequ�ncia de bits lida do arquivo com sucesso.');

    % Decodificar a imagem
    imagemHuffman_decodificada = huffmandeco(sequencia_huffmanLida, tabela_huffman);
    disp('Imagem decodificada com sucesso.');

    % Reconstruir a imagem
    imagemHuffman_reconstruida = reshape(imagemHuffman_decodificada, size(imagem_pnm));

    % Exibir a compara��o entre a imagem original e a imagem reconstru�da ap�s a decodifica��o
    subplot(1, 2, 1);
    imshow(uint8(imagem_pnm));
    title('Imagem Original');

    subplot(1, 2, 2);
    imshow(uint8(imagemHuffman_reconstruida));
    title('Imagem Reconstru�da ap�s Decodifica��o');

    sgtitle('Compara��o Huffman:');
    
    % Verificar se a imagem reconstru�da corresponde � imagem original
    if isequal(imagem_pnm, imagemHuffman_reconstruida)
        disp('Verifica��o de igualdade bem-sucedida. A imagem reconstru�da corresponde � imagem original.');
    else
        disp('Aten��o: A imagem reconstru�da N�O corresponde � imagem original.');
    end
    
    disp("------------------------------------------------------------")
    
    % Passo 3: Codifica��o de Shannon-Fano aplicada � diferen�a m�vel dos pixels
    disp('Passo 3: Codifica��o de Shannon-Fano aplicada � diferen�a m�vel dos pixels')
    
    % Constru��o da tabela de Shannon-Fano com base nas probabilidades
    tabela_sf = shannonfanodict(0:255, prob_imagem);
    disp('Tabela de Shannon Fano criada com sucesso.')
    % Mapeamento dos s�mbolos para c�digos de Shannon-Fano
    sf_mapping = shannonfanoenco(vetor_imagem, tabela_sf);
  
    % Codifica��o da imagem usando os c�digos de Shannon-Fano
    sequencia_shannonFano = sf_mapping';
    disp('C�digos Huffman gerados com sucesso.')

    % Armazenamento da sequ�ncia de bits comprimida em um arquivo
    fid = fopen('imagemShannonFano_codificada.bin', 'wb');
    fwrite(fid, sequencia_shannonFano, 'ubit1');
    fclose(fid);
    disp('Sequ�ncia de bits comprimida armazenada em arquivo com sucesso.');

    disp("------------------------------------------------------------")

    % Passo 4: Decodifica��o de Shannon-Fano aplicada � diferen�a m�vel dos pixels
    disp('Passo 4: Decodifica��o de Shannon-Fano aplicada � diferen�a m�vel dos pixels')
    fid = fopen('imagemHShannonFano_codificada.bin', 'rb');
    sequencia_shannonFanoLida = fread(fid);
    fclose(fid);
    disp('Sequ�ncia de bits lida do arquivo com sucesso.');
    
    % Decodifica��o da sequ�ncia de bits comprimida
    imagemShannonFano_decodificada = shannonfanodeco(sequencia_shannonFanoLida, tabela_sf);
    disp('Imagem decodificada com sucesso.')
    % Reconstru��o da imagem a partir dos c�digos de Shannon-Fano decodificados
    imagemShannonFano_reconstruida = reshape(imagemShannonFano_decodificada, size(imagem_pnm));

    % Exibe a compara��o entre a imagem original e a imagem reconstru�da ap�s a decodifica��o
    subplot(1, 2, 1);
    imshow(uint8(imagem_pnm));
    title('Imagem Original');

    subplot(1, 2, 2);
    imshow(uint8(imagem_decodificada));
    title('Imagem Reconstru�da ap�s Decodifica��o');

    sgtitle('Compara��o Shannon-Fano:');
    
    disp('Verifica��o de igualdade bem-sucedida. A imagem reconstru�da corresponde � imagem original.');
