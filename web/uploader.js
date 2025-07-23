/**
 * Opens a file chooser dialog.
 * @param {string} accept - The file types to accept.
 * @returns {Promise<{filename: string, size: number, file: File}>} - A promise that resolves to the selected file.
 */
async function ChooseAFile(accept = '*/*', onPick = null) {
    const result = new Promise((resolve, reject) => {
        const input = document.createElement('input');
        input.type = 'file';
        input.accept = accept;
        input.onchange = () => {
            const file = input.files[0];
            if (file) {
                const result = {
                    filename: file.name,
                    size: file.size,
                    file: file,
                    blob: URL.createObjectURL(file),
                };
                resolve(result);
                if(onPick) {
                    onPick(
                        JSON.stringify(result)
                    );
                }
            } else {
                reject(new Error('No file selected'));
            }
        };
        input.click();
    });

    return await result;
}

/**
 * 
 * @param {string} url 
 * @param {File} file 
 * @param {Function} onProgress - Callback for upload progress
 * @return {Promise<{file_id: string, url: string, success: boolean, message: string}>}
 */
function UploadAFile(url = '', file = null, onProgress = null) {
    return new Promise((resolve, reject) => {
        try {
            if (!file) {
                throw new Error('No file provided');
            }

            // Create FormData directly from File object
            const formData = new FormData();
            formData.append('file', file);

            // Upload using fetch with progress monitoring
            const xhr = new XMLHttpRequest();
            xhr.open('POST', url, true);

            // Progress handler
            xhr.upload.onprogress = (event) => {
                if (onProgress && event.lengthComputable) {
                    const progress = Math.min(Math.ceil((100 * event.loaded) / event.total), 100);
                    onProgress({
                        percent: progress,
                        sent: event.loaded,
                        total: event.total
                    });
                }
            };

            // Response handler
            xhr.onload = () => {
                if (xhr.status === 200) {
                    try {
                        const result = JSON.parse(xhr.responseText);
                        resolve({
                            success: result.status,
                            message: result.message,
                            url: result.current_path,
                            file_id: result.file.file_id
                        });
                    } catch (error) {
                        reject(new Error('Invalid response format'));
                    }
                } else {
                    reject(new Error(`Upload failed with status ${xhr.status}`));
                }
            };

            // Error handler
            xhr.onerror = () => {
                reject(new Error('Network error occurred'));
            };

            // Send the request
            xhr.send(formData);
        } catch (error) {
            reject(error);
        }
    });
}