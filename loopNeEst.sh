#!/bin/bash
# used for rarefaction of data subsets

TYPE=1  # This is the method selection (e.g., 1 = Linkage Disequilibrium)

for FILE in BtwnSubset_*.ped.genepop.txt
do
    # Check if the file exists before processing it
    if [ ! -f "$FILE" ]; then
        echo "File $FILE not found!"
        continue  # Skip to the next file if it doesn't exist
    fi

    echo "Processing: $FILE"

    # Send the file name first, followed by the method selection (TYPE)
    # Simulate pressing Enter after the output filename is proposed
    {
        echo "$FILE"  # File name (first input)
        echo "$TYPE"  # Method selection (second input)
        echo ""       # Simulate pressing Enter (empty input) for output file confirmation
    } | ./programFiles/Ne2-1L

    echo "Processed: $FILE"
    echo ""
done
