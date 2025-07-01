process create_index {
    input:
    path fasta
    
    output:
    path fasta, emit: indexed_fasta
    path "*.fai", emit: index_file
    
    script:
    """
    samtools faidx ${fasta}
    """
}

process split_coordinates {
    input:
    path coordinates_file
    
    output:
    path "coordinates_parsed.txt", emit: coords_file
    
    script:
    """
    #!/usr/bin/env python3
    with open('${coordinates_file}', 'r') as f:
        with open('coordinates_parsed.txt', 'w') as out:
            for line in f:
                parts = line.strip().split()
                if len(parts) == 3:
                    contig, pos1, pos2 = parts
                    start = min(int(pos1), int(pos2))
                    stop = max(int(pos1), int(pos2))
                    out.write(f'{contig}\\t{start}\\t{stop}\\n')
                if len(parts) == 1:
                    contig = parts[0]
                    out.write(f'{contig}\\n')
    """
}

process samtools_extract { 
    publishDir 'results', mode: 'copy'
    
    input:
    tuple path(fasta), path(coordinates_file)

    output:
    path "*.fa", emit: extracted_fasta

    script:
    """
    #!/usr/bin/env python3
    import subprocess
    import os
    
    with open('${coordinates_file}', 'r') as f:
        for line in f:
            parts = line.strip().split('\\t')
            contig = parts[0]
            
            if len(parts) == 3 and parts[1] and parts[2]:
                # Extract specific region
                start, stop = parts[1], parts[2]
                output_file = f'{contig}.{start}.{stop}.fa'
                cmd = f'samtools faidx ${fasta} {contig}:{start}-{stop} > {output_file}'
            else:
                # Extract entire contig
                output_file = f'{contig}.full.fa'
                cmd = f'samtools faidx ${fasta} {contig} > {output_file}'
            
            subprocess.run(cmd, shell=True, check=True)
    """
}
