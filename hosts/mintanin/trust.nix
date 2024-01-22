{ config, pkgs, ... }: { 
  users.users.nrb = {  # Define a user account. Don't forget to set a password with ‘passwd’.
    extraGroups = [  "networkmanager" "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5zFqMXN4dgTzMt0LFPhl+wSxiJAUKHY9rE32dU2vri1or6CCiLdQRJUy79ovEa1bRa8p3C3F+5B+1mMssFnbotSmZ0/RSWy3sYazc4nfJkhJS50AU7T+LPWS20UNexbcEQRn6FjNsFPmKoUozToXRwbbg91IJEYyHXHnttNzBiUle5SPKYM8OF/ZZTHwgjpD82lSkh5Vek8CmYIuNeZWXYgxOBoboSjFmDLjKFVFufi2evyw18xeMtXeLNx8nPmk4WqLqX8z/S8eBK+D85LPU38+8H1WgYEVLgSuvgB5qzDq3MQR50MzC+MWvbO4Na3/XIo7RAV3XXaLJnI8Q6f9QyPlbe8Id3R2Bo8i9z9i8J3++6ZIeeDh12pOUI8Mg/mXZhiSAiIfsSxd9VLt7BlXzDn8MqWQewoh/tZVpHOsHK3onC9hovp1LAm6Q3r3ZKxTmakLLD8UdQtM8cIiHawWO2RRHQvCs7zDuUjVNd7mrpcugj/xC8kSDb25DGWhv8jE= nrb@mintanin"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCrs4NV63V7zNQlBiQrlSoioFkcy8EQX/Qsp0YqbHpj3cfL0kid4QzsEpieZJMyg/kdPhN2Cv3kPwHqd7SU4HeTl5tJYE7XFyI9+T6D+BGEUI5tV78hueDJZjOa93jd8H8RfN7xKoBSl/hOEwyEi99X/Q4OCpUcp15pDqqoC89IfBxzid6gy/072jAgMBeLUzujPFYZsybqP2Pj7FCAuwx/h51E9cbxAUtISLyxblpqj3DPh2NcRxPD5NDCKwBMVEc3nkeNTsN3FE9diw4Ebs3D3TT0nZRN+0P05NPg7bxoDcYeV6inrun/geURKKHCFrM5Htwnd8TulTuXt/gjbX/aDmMiRkKgEw9C0CPaQwwAx9H0OkfZmwr/acaTBhRtqNbiyxA1Do6gb6rldoLnXRxjww4VVKcN1EuTqpW8FNR+9HMTM4JYZW8ZldoE2lms0FH68c2QF46z6HqZGpbWLZy4Hr5g/8JCF2IzWFbjLaxTxk+jngLkrfvLYHF+9Q61IOM= nrb@redwider"
      ];
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD79k4L7xCQX+7CqrqkLs2BPfgXrcqbZfFubsk8DcuQeLiNyA+kyDDXaW88Y98CFLDO3C3EPJa/zeSM24rBCqQ7sySITzgC+gE4qqGg4LmRkR7YOQkAImtKSt5mcJxOgTGULkYKRU3s+5MIBoH7QrIMrsPUagfOOn+MZnPJ/90E0U69fRWsT3Nj+teotQsPDUJM3onbjgUfc08vbwmHdIEZD8MG5Pomn2jKId9kBtK9JEPSfu8xT7sI/aaaM0/h7Zgg1lL+JVdaNARzTUbqlIj0CNOOe8x3zVWwAwXDUGESruJiKlquTLC6AVr30seWOeIK6LExnZ/zOVe1JOciCFY3 nrb@x1t" 
    ];
}
