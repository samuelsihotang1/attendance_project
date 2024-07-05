<form method="POST" action="{{ url('/login') }}">
    @csrf

    <div>
        <label for="username">Username</label>
        <input id="username" type="text" name="username" value="{{ old('username') }}" required autocomplete="username"
            autofocus>
        @error('username')
        <span role="alert">{{ $message }}</span>
        @enderror
    </div>

    <div>
        <label for="password">Password</label>
        <input id="password" type="password" name="password" required autocomplete="current-password">
        @error('password')
        <span role="alert">{{ $message }}</span>
        @enderror
    </div>

    <div>
        <label for="password_confirmation">Konfirmasi Password</label>
        <input id="password_confirmation" type="password" name="password_confirmation" required autocomplete="current-password">
        @error('password')
        <span role="alert">{{ $message }}</span>
        @enderror
    </div>

    <div>
        <button type="submit">
            Login
        </button>
    </div>
</form>