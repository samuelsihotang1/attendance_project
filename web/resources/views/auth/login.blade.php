<div>
    <main class="auth-minimal-wrapper">
        <div class="auth-minimal-inner">
            <div class="minimal-card-wrapper">
                <div class="d-flex justify-content-center align-items-center">
                    <img src="assets_2/images/logo.png" alt="" class="img-fluid" style="height: 17vh;">
                </div>
                <div class="card mb-4 mt-5 mx-4 mx-sm-0 position-relative">
                    <div class="card-body p-sm-5">
                        <h2 class="fs-20 fw-bolder mb-4">Login</h2>
                        <form wire:submit.prevent="login" class="w-100 mt-4 pt-2">
                            @csrf
                            <div class="mb-4">
                                <input type="text" wire:model="nip" class="form-control" placeholder="NIP" required
                                    autocomplete="nip">
                                @error('nip')
                                <span role="alert">{{ $message }}</span>
                                @enderror
                            </div>
                            <div class="mb-3">
                                <input type="password" wire:model="password" class="form-control" placeholder="Password"
                                    autocomplete="current-password" required>
                                @error('password')
                                <span role="alert">{{ $message }}</span>
                                @enderror
                            </div>
                            <div class="mt-5">
                                <button type="submit" class="btn btn-lg btn-primary w-100">Login</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>